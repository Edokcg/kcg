--No.99 希望皇ホープドラグナー
--Number 99: Utopia Dragner
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,12,3,nil,nil,Xyz.InfiniteMats,nil,false)
    aux.EnableCheckRankUp(c,nil,nil,84013237)

 	--cannot destroyed
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e0:SetValue(s.indes)
    c:RegisterEffect(e0)

	--immune
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e01:SetCode(EFFECT_IMMUNE_EFFECT)
	e01:SetRange(LOCATION_MZONE)
	e01:SetTargetRange(LOCATION_ONFIELD,0)
	e01:SetValue(s.efilter)
	e01:SetLabel(RESET_EVENT+RESETS_STANDARD)   
    
    local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_RANKUP_EFFECT)
	e02:SetLabelObject(e01)
	c:RegisterEffect(e02)

	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--ATK to 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15240238,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(Cost.DetachFromSelf(1))
	e3:SetCondition(s.descondition)
	e3:SetTarget(s.destarget)
	e3:SetOperation(s.desactivate)
	c:RegisterEffect(e3)

	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_series={0x48}
s.xyz_number=99
s.listed_names={84013237}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.counterfilter(c)
	return c:IsType(TYPE_XYZ) or c:GetSummonLocation()~=LOCATION_EXTRA
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(id,2))
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ge1:SetTargetRange(1,0)
	ge1:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ) end)
	ge1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(ge1,tp)
	--"Clock Lizard" check
	aux.addTempLizardCheck(c,tp,function(e,c) return not c:IsOriginalType(TYPE_XYZ) end)
end

function s.filter(c,e,tp,rp)
	return c:IsSetCard(0x48) and c.xyz_number and c.xyz_number>=1 and c.xyz_number<=100
		and Duel.GetLocationCountFromEx(tp,rp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp~=e:GetHandler():GetControler() 
		and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end

function s.descondition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	if Duel.IsBattlePhase() and rp==1-tp and re:IsMonsterEffect() then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	return eb and tg and tg:IsContains(e:GetHandler())
end
function s.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.desactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local sum=dg:GetSum(Card.GetAttack)
		Duel.Damage(1-tp,sum,REASON_EFFECT)
	end
end