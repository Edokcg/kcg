--Orichlachos Kytora
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--Negates Battle Damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(s.rdcon)
	e2:SetOperation(s.rdop)
	c:RegisterEffect(e2)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5398,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

	--suicide
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(123104,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)

	local e8 = Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e8:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD_P)
	e8:SetOperation(s.recover)
	c:RegisterEffect(e8)
end
s.listed_names={12399}
s.counter_place_list={0x1088}

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	Duel.CheckLPCost(c:GetControler(),500)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)
	else Duel.PayLPCost(tp,500) end
end

function s.filter(c,e,tp)
	return c:IsCode(12399) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local val=c:GetFlagEffectLabel(id)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and val and val>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=c:GetFlagEffectLabel(id)
	if not val or val<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val)
		tc:RegisterEffect(e1,true)
	end
end

function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil and ep==tp and ev>0
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetAttackTarget()~=nil and ep==tp and ev>0 then
		c:AddCounter(0x1088,ev)
		Duel.ChangeBattleDamage(tp,0)
	end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.recover(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=c:GetCounter(0x1088)
	if val<1 or not c:IsReason(REASON_DESTROY) then return end
	c:RegisterFlagEffect(id,RESET_EVENT+RESET_TOFIELD,0,1,val)
end