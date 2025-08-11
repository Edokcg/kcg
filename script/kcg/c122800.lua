local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,s.ffilter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)

	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetCondition(s.con2)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tfilter)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.con)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(s.con)
	e6:SetTarget(s.tfilter3)
	c:RegisterEffect(e6)

	--damage
	--local e7=Effect.CreateEffect(c)
	--e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	--e7:SetDescription(aux.Stringid(122800,1))
	--e7:SetCategory(CATEGORY_DAMAGE)
	--e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	--e7:SetRange(LOCATION_MZONE)
	--e7:SetCountLimit(1)
	--e7:SetCondition(s.damcon)
	--e7:SetTarget(s.damtg)
	--e7:SetOperation(s.damop)
	--c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetValue(1)
	c:RegisterEffect(e8)

	--battle indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e9:SetCountLimit(1)
	e9:SetValue(s.valcon)
	c:RegisterEffect(e9)
end
s.listed_series={0x900}
s.material_setcode={0x900}

function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x900,fc,sumtype,tp) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ,FC,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.con2(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.IsExistingMatchingCard(Card.IsSetCard,1-e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x900)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,1-e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x900)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.tfilter(e,c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.tfilter3(e,c)
	return c:GetBaseAttack()>=c:GetAttack()
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(e:GetHandler():GetControler())
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1500)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end

-- function s.spfilter(c,tp,sc)
--  return c:IsSetCard(0x900) and c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
--  and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_ONFIELD,0,1,c,c,tp,sc)
-- end
-- function s.spfilter2(c,tc,tp,sc)
--  return c:IsSetCard(0x900) and c:IsCanBeFusionMaterial() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
--  and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc),sc)>0
-- end
-- function s.sprcon(e,c)
--  if c==nil then return true end 
--  local tp=c:GetControler()
--  return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler())
-- end
-- function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
--  if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler()) then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
--  local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,e:GetHandler())
--  if #g<1 then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
--  local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_MZONE,0,1,1,g:GetFirst(),g:GetFirst(),tp,e:GetHandler())
--  if #g2<1 then return end
--  g:Merge(g2)
--  local tc=g:GetFirst()
--  while tc do
--  if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
--  tc=g:GetNext()
--  end
--  e:GetHandler():SetMaterial(g) 
--  Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL+REASON_FUSION)
-- end
