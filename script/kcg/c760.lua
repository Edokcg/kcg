--Vijam the Cubic Seed (Movie)
local s,id=GetID()
function s.initial_effect(c)
	--cannot destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15610297,0))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(function(e) return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_VIJAM),e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil) end)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)

	--movetofield
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetDescription(aux.Stringid(15610297,1))
	-- e3:SetType(EFFECT_TYPE_IGNITION)
	-- e3:SetRange(LOCATION_SZONE)
	-- e3:SetTarget(s.sptg)
	-- e3:SetOperation(s.spop)
	-- c:RegisterEffect(e3)

	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_DESTROY)
	e8:SetLabelObject(e3)
	e8:SetRange(LOCATION_SZONE)
	e8:SetOperation(s.op2)
	c:RegisterEffect(e8)
	
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(s.spsop)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.op)
	e5:SetLabelObject(e7)
	c:RegisterEffect(e5)
end
s.listed_series={0xe3}
s.listed_names={CARD_VIJAM}

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsLocation(LOCATION_MZONE) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(511004447,RESET_EVENT+0x1fc0000,0,1)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local bc=g:GetFirst()
	for bc in aux.Next(g) do
		bc:AddCounter(0x1038,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(s.condition)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		bc:RegisterEffect(e2)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_MATERIAL)
        e4:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
		bc:RegisterEffect(e4)
	end
end
function s.condition(e)
	return e:GetHandler():GetCounter(0x1038)>0
end

function s.costfilter(c)
	return c:IsSetCard(0xe3) and c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.damfilter,nil)
	if g:GetCount()>0 then
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g) end
end
function s.damfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetCounter(0x1038)>0 and c:IsReason(REASON_DESTROY)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g or g:GetCount()<1 then return end
	for tc in aux.Next(g) do
		local ctl=tc:GetControler()
		if tc:IsPreviousPosition(POS_ATTACK) then
			Duel.Damage(ctl,tc:GetPreviousAttackOnField(),REASON_EFFECT,true)
		elseif tc:IsPreviousPosition(POS_DEFENSE) then
			Duel.Damage(ctl,tc:GetPreviousDefenseOnField(),REASON_EFFECT,true)
		end
	end
	Duel.RDComplete()
	g:DeleteGroup()
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3)
end
function s.spsop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	if not mg or mg:FilterCount(s.spfilter,nil,e,tp)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<mg:GetCount() 
	   or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and mg:GetCount()>1) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	mg:DeleteGroup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if g:GetCount()>0 then
	local mg=g:Filter(s.spfilter,nil,e,tp)
	mg:KeepAlive()
	e:GetLabelObject():SetLabelObject(mg) end
end