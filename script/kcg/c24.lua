--ユベル－Das Extremer Traurig Drachen
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(s.fscondition)
	e1:SetOperation(s.fsoperation)
	c:RegisterEffect(e1)
 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)

	--spsummon success
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)   
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(s.sucop)
	c:RegisterEffect(e6)

	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(s.splimit)
	c:RegisterEffect(e5)
	--特殊召唤不会被无效化
	local e51=Effect.CreateEffect(c)
	e51:SetType(EFFECT_TYPE_SINGLE)
	e51:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e51:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e51)

	--不能被各种方式解放
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_UNRELEASABLE_SUM)
	e12:SetValue(1)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e14)

	--不会被卡的效果破坏、除外、返回手牌和卡组、送去墓地、无效化、改变控制权、变为里侧表示、作为特殊召唤素材
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e101)
	local e102=e101:Clone()
	e102:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e102)
	local e103=e102:Clone()
	e103:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e103)
	local e104=e103:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105=e104:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106=e105:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e106:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e107:Clone()
	e108:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e108:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
    c:RegisterEffect(e108)
	local e111=e100:Clone()
	e111:SetCode(EFFECT_CANNOT_RELEASE)
	c:RegisterEffect(e111)

	--immune
	local e121=Effect.CreateEffect(c)
	e121:SetType(EFFECT_TYPE_SINGLE)
	e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e121:SetRange(LOCATION_MZONE)
	e121:SetCode(EFFECT_IMMUNE_EFFECT)
	e121:SetValue(s.efilter)
	c:RegisterEffect(e121)

	--不能成为对方的卡的效果对象
	local e122=Effect.CreateEffect(c)
	e122:SetType(EFFECT_TYPE_SINGLE)
	e122:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e122:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e122:SetRange(LOCATION_MZONE)
	e122:SetValue(s.tgvalue)
	c:RegisterEffect(e122)
end
s.listed_names={48130397,31764700,4779091,78371393}

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(48130397,23)
end

function s.spfilter1(c)
	return c:GetLevel()==1
end
function s.spfilter2(c)
	return c:GetLevel()==2
end
function s.spfilter3(c)
	return c:GetLevel()==3
end
function s.spfilter4(c)
	return c:GetLevel()==4
end
function s.spfilter5(c)
	return c:GetLevel()==5
end
function s.spfilter6(c)
	return c:GetLevel()==6
end
function s.spfilter7(c)
	return c:GetLevel()==7
end
function s.spfilter8(c)
	return c:GetLevel()==8
end
function s.spfilter9(c)
	return c:GetLevel()==9
end
function s.spfilter10(c)
	return c:GetLevel()==10
end
function s.spfilter11(c)
	return c:GetLevel()==11
end
function s.spfilter12(c,e)
	return c:GetLevel()==12 and c~=e:GetHandler()
end
function s.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return false end
	local g1=g:Filter(s.spfilter1,nil)   
	  local c1=g1:GetCount()
	local g2=g:Filter(s.spfilter2,nil)   
	  local c2=g2:GetCount()
	local g3=g:Filter(s.spfilter3,nil)   
	  local c3=g3:GetCount()
	local g4=g:Filter(s.spfilter4,nil)   
	  local c4=g4:GetCount()
	local g5=g:Filter(s.spfilter5,nil)   
	  local c5=g5:GetCount()
	local g6=g:Filter(s.spfilter6,nil)   
	  local c6=g6:GetCount()
	local g7=g:Filter(s.spfilter7,nil)   
	  local c7=g7:GetCount()
	local g8=g:Filter(s.spfilter8,nil)   
	  local c8=g8:GetCount()
	local g9=g:Filter(s.spfilter9,nil)   
	  local c9=g9:GetCount()
	local g10=g:Filter(s.spfilter10,nil) 
	  local c10=g10:GetCount()
	local g11=g:Filter(s.spfilter11,nil) 
	  local c11=g11:GetCount()
	local g12=g:Filter(s.spfilter12,nil,e) 
	  local c12=g12:GetCount()
	local ag=g1:Clone()
	ag:Merge(g2)
	ag:Merge(g3)
	ag:Merge(g4)
	ag:Merge(g5)
	ag:Merge(g6)
	ag:Merge(g7)
	ag:Merge(g8)
	ag:Merge(g9)
	ag:Merge(g10)
	ag:Merge(g11)
	ag:Merge(g12)
	--if chkf~=PLAYER_NONE and not ag:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return ag:GetCount()>=12 and c1>=1 and c2>=1 and c3>=1 and c4>=1 and c5>=1 and c6>=1 and c7>=1 and c8>=1 and c9>=1 and c10>=1 and c11>=1 and c12>=1										
end
function s.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	if gc then return end
	local c=e:GetHandler()
	local g111=eg:Filter(s.spfilter1,nil)   
	  local c1=g111:GetCount()
	local g112=eg:Filter(s.spfilter2,nil)   
	  local c2=g112:GetCount()
	local g113=eg:Filter(s.spfilter3,nil)   
	  local c3=g113:GetCount()
	local g114=eg:Filter(s.spfilter4,nil)   
	  local c4=g114:GetCount()
	local g115=eg:Filter(s.spfilter5,nil)   
	  local c5=g115:GetCount()
	local g116=eg:Filter(s.spfilter6,nil)   
	  local c6=g116:GetCount()
	local g117=eg:Filter(s.spfilter7,nil)   
	  local c7=g117:GetCount()
	local g118=eg:Filter(s.spfilter8,nil)   
	  local c8=g118:GetCount()
	local g119=eg:Filter(s.spfilter9,nil)   
	  local c9=g119:GetCount()
	local g1110=eg:Filter(s.spfilter10,nil) 
	  local c10=g1110:GetCount()
	local g1111=eg:Filter(s.spfilter11,nil) 
	  local c11=g1111:GetCount()
	local g1112=eg:Filter(s.spfilter12,nil,e) 
	  local c12=g1112:GetCount()
	  local ag2=g111:Clone()
	ag2:Merge(g112)
	ag2:Merge(g113)
	ag2:Merge(g114)
	ag2:Merge(g115)
	ag2:Merge(g116)
	ag2:Merge(g117)
	ag2:Merge(g118)
	ag2:Merge(g119)
	ag2:Merge(g1110)
	ag2:Merge(g1111)
	ag2:Merge(g1112)

	if ag2:GetCount()>=12 and c1>=1 and c2>=1 and c3>=1 and c4>=1 and c5>=1 and c6>=1 and c7>=1 and c8>=1 and c9>=1 and c10>=1 and c11>=1 and c12>=1 then   
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,s.spfilter1,1,1,nil)   
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=eg:FilterSelect(tp,s.spfilter2,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)	
	local g3=eg:FilterSelect(tp,s.spfilter3,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)	
	local g4=eg:FilterSelect(tp,s.spfilter4,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)	
	local g5=eg:FilterSelect(tp,s.spfilter5,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)   
	local g6=eg:FilterSelect(tp,s.spfilter6,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)  
	local g7=eg:FilterSelect(tp,s.spfilter7,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)	
	local g8=eg:FilterSelect(tp,s.spfilter8,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)   
	local g9=eg:FilterSelect(tp,s.spfilter9,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)	
	local g10=eg:FilterSelect(tp,s.spfilter10,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)  
	local g11=eg:FilterSelect(tp,s.spfilter11,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)  
	local g12=eg:FilterSelect(tp,s.spfilter12,1,1,nil,e)  
	  local ag=g1:Clone()
	ag:Merge(g2)
	ag:Merge(g3)
	ag:Merge(g4)
	ag:Merge(g5)
	ag:Merge(g6)
	ag:Merge(g7)
	ag:Merge(g8)
	ag:Merge(g9)
	ag:Merge(g10)
	ag:Merge(g11)
	ag:Merge(g12)
	Duel.SetFusionMaterial(ag)  end
end

function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atker=e:GetHandler():GetBattleTarget()
	if chk==0 then return atker~=nil and atker:IsOnField() and not atker:IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,atker,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,atker:GetAttack()) 
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local atker=e:GetHandler():GetBattleTarget()
	if atker~=nil and atker:IsOnField() and not atker:IsStatus(STATUS_BATTLE_DESTROYED) then
	if Duel.Destroy(atker,REASON_EFFECT)<1 then return end
	  local dg=Duel.GetOperatedGroup()
	  local tatk=0
	  for dgc in aux.Next(dg) do
	  local atk=dgc:GetPreviousAttackOnField()
	  if atk<0 then atk=0 end
	  tatk=tatk+atk
	  end
	  Duel.Damage(0,tatk,REASON_EFFECT)
	  Duel.Damage(1,tatk,REASON_EFFECT)
	  Duel.RDComplete()
	end
end

function s.valcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g<1 then return end
	if g:IsExists(Card.IsCode,1,nil,31764700) and g:IsExists(Card.IsCode,1,nil,4779091) and g:IsExists(Card.IsCode,1,nil,78371393) then 
		--spsummon success
		local e6=Effect.CreateEffect(c)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)   
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(s.sucop)
		e6:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e6)
		--battle
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e2)
		local e0=Effect.CreateEffect(c)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e0)
		--damage
		local e32=Effect.CreateEffect(c)
		e32:SetDescription(aux.Stringid(31764700,0))
		e32:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e32:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e32:SetRange(LOCATION_MZONE)
		e32:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e32:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e32:SetTarget(s.rdtg)
		e32:SetOperation(s.rdop)
		e32:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e32)
		local e19=Effect.CreateEffect(c)
		e19:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
		e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e19:SetCode(EVENT_ZERO_LP)
		e19:SetRange(LOCATION_MZONE)
		e19:SetOperation(s.activate)
		e19:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e19) 
		--Pos Change
		local e203=Effect.CreateEffect(c)
		e203:SetType(EFFECT_TYPE_FIELD)
		e203:SetCode(EFFECT_SET_POSITION)
		e203:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e203:SetRange(LOCATION_MZONE)
		e203:SetTargetRange(0,LOCATION_MZONE)
		e203:SetCondition(s.poscon)
		e203:SetValue(POS_FACEUP_ATTACK)
		e203:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e203)
		--must attack
		local e204=Effect.CreateEffect(c)	
		e204:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e204:SetType(EFFECT_TYPE_FIELD)
		e204:SetCode(EFFECT_MUST_ATTACK)
		e204:SetRange(LOCATION_MZONE)
		e204:SetTargetRange(0,LOCATION_MZONE)
		e204:SetCondition(s.atkcon)
		e204:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e204)
		local e205=e204:Clone()
		e205:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		c:RegisterEffect(e205)
		local e206=Effect.CreateEffect(c)
		e206:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e206:SetType(EFFECT_TYPE_SINGLE)
		e206:SetCode(EFFECT_ONLY_BE_ATTACKED)
		e206:SetCondition(s.condition)
		e206:SetValue(1)
		e206:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e206)
		local e90=Effect.CreateEffect(c)
		e90:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e90:SetCode(EVENT_LEAVE_FIELD)
		e90:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
		e90:SetLabelObject(e6)
		e90:SetCondition(s.acondition)
		e90:SetOperation(s.aactivate)
		e90:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e90)
	else
		local e6=Effect.CreateEffect(c)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)   
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(s.sucop2)
		e6:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e6)
	end
end

function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(Duel.GetLP(1-tp))
end

function s.sucop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ag=g:Select(tp,3,3,nil)
	local tx=ag:GetFirst()
	while tx do
		local code=tx:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+EVENT_TO_DECK,1)  
		tx=ag:GetNext() 
	end
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp
end
function s.atkcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp~=e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.poscon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and ph>=0x8 and ph<=0x20
end

function s.acondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.aactivate(e,tp,eg,ep,ev,re,r,rp)
	local lp1=e:GetLabelObject():GetLabel()
	local lp2=Duel.GetLP(1-tp)
	if lp1~=lp2 then
	local dif=((lp1>lp2) and (lp1-lp2)) or (lp2-lp1)
	Duel.SetLP(1-tp,dif+1,REASON_EFFECT)
	else
	Duel.SetLP(1-tp,1,REASON_EFFECT)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if re and ep==tp then
		Duel.SetLP(tp,1)
		Duel.SendtoDeck(Duel.GetFieldGroup(tp,0,LOCATION_GRAVE),0,-2,REASON_RULE)
	end
end
