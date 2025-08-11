--キメラテック·フォートレス·ドラゴン
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),1,99,CARD_CYBER_DRAGON)
	Fusion.AddContactProc(c,s.contactfil,s.contactop)
	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	--fusion material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_FUSION_MATERIAL)
	e2:SetCondition(s.fscondition)
	e2:SetOperation(s.fsoperation)
	--c:RegisterEffect(e2)

	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.sucop)
	c:RegisterEffect(e3)

	  local e4=Effect.CreateEffect(c)
	  e4:SetType(EFFECT_TYPE_FIELD)
	  e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	  e4:SetRange(LOCATION_MZONE)
	  e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	  e4:SetCondition(s.indescondition)
	  e4:SetTarget(s.battarget)
	  e4:SetValue(1)
	  c:RegisterEffect(e4)

	--no battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	  e5:SetRange(LOCATION_MZONE)
	  e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	  e5:SetCondition(s.indescondition)
	  e5:SetTarget(s.battarget)
	  e5:SetValue(1)
	c:RegisterEffect(e5)

	  local e6=Effect.CreateEffect(c)
	  e6:SetDescription(aux.Stringid(20,0)) 
	  e6:SetCategory(CATEGORY_DAMAGE) 
	  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	  e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	  e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	  e6:SetTarget(s.attg)
	e6:SetOperation(s.attop)
	  c:RegisterEffect(e6)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(s.tgop)
	c:RegisterEffect(e8)
end
s.material_setcode={0x93,0x1093}
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end

function s.spfilter(c,mg)
	return (c:IsCode(70095154) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE))
		and mg:IsExists(Card.IsRace,1,c,RACE_MACHINE)
end
function s.fscondition(e,mg,gc)
	if mg==nil then return false end
	if gc then return false end
	return mg:IsExists(s.spfilter,1,nil,mg)
end
function s.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,s.spfilter,1,1,nil,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=eg:FilterSelect(tp,Card.IsRace,1,63,g1:GetFirst(),RACE_MACHINE)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end

function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function s.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function s.dircon2(e)
	return e:GetHandler():IsDirectAttacked()
end

function s.indescondition(e,tp,eg,ep,ev,re,r,rp)
	  return Duel.GetAttacker()==e:GetHandler()
end
function s.battarget(e,tp,eg,ep,ev,re,r,rp,chk)
	  local c=e:GetHandler()
	  if chk==0 then return Duel.GetAttacker()==c end
	  return c and c:GetBattleTarget()
end

function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	  Duel.SetTargetPlayer(1-tp)
	  Duel.SetTargetParam(400)
	  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400) 
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end