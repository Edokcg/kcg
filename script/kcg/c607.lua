--Raidraptor - Last Strix
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon + Recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

	-- local e5=Effect.CreateEffect(c)
	-- e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_SUMMON_SUCCESS)
	-- e5:SetOperation(s.atkop)
	-- c:RegisterEffect(e5)
	-- local e10=e5:Clone()
	-- e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e10)
	-- local e98=e5:Clone()
	-- e98:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	-- c:RegisterEffect(e98)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	--return d and ((a:GetControler()==tp and a:IsSetCard(0xba)) or (d:GetControler()==tp and d:IsSetCard(0xba)))
      return Duel.GetBattleDamage(tp)>0
end
function s.cost(e,tp,eg,ep,ev,re,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,607)==0 end
	Duel.RegisterFlagEffect(tp,607,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
      local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
      local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(s.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
      e1:SetLabel(ct)
	Duel.RegisterEffect(e1,tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local ct=e:GetLabel()
	if Duel.GetBattleDamage(tp)-(ct*1000)>0 then Duel.ChangeBattleDamage(tp,Duel.GetBattleDamage(tp)-(ct*1000))
	else Duel.ChangeBattleDamage(tp,0) end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(592,RESET_EVENT+0x1fe0000,0,1)
end